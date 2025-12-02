from flask import Flask, render_template, request, jsonify, session, redirect, url_for
from models import db, Team, Score, AdminSettings, COURSE_PARS, COURSE_NAME
from datetime import datetime, timedelta
import os
import secrets

app = Flask(__name__)

# Configuration
basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{os.path.join(basedir, "golf_scramble.db")}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = secrets.token_hex(16)  # For session management

# Initialize database
db.init_app(app)

# Lock timeout in minutes
LOCK_TIMEOUT_MINUTES = 30


def check_and_release_expired_locks():
    """Release locks that have expired (older than LOCK_TIMEOUT_MINUTES)"""
    timeout = datetime.utcnow() - timedelta(minutes=LOCK_TIMEOUT_MINUTES)
    expired_teams = Team.query.filter(
        Team.is_locked == True,
        Team.locked_at < timeout
    ).all()
    
    for team in expired_teams:
        team.is_locked = False
        team.locked_at = None
        team.locked_by = None
    
    if expired_teams:
        db.session.commit()
    
    return len(expired_teams)


@app.route('/')
def index():
    """Team selection page"""
    return render_template('index.html')


@app.route('/scorecard/<int:team_id>')
def scorecard(team_id):
    """Scorecard entry page for a specific team"""
    team = Team.query.get_or_404(team_id)
    return render_template('scorecard.html', team=team)


@app.route('/api/teams', methods=['GET'])
def get_teams():
    """Get all teams with their lock status"""
    check_and_release_expired_locks()
    
    teams = Team.query.order_by(Team.id).all()
    teams_data = []
    
    for team in teams:
        team_dict = team.to_dict()
        team_dict['total_score'] = team.get_total_score()
        team_dict['relative_to_par'] = team.get_score_relative_to_par()
        
        # Check if locked by current session
        team_dict['locked_by_me'] = (
            team.is_locked and 
            team.locked_by == session.get('session_id')
        )
        
        teams_data.append(team_dict)
    
    return jsonify(teams_data)


@app.route('/api/team/<int:team_id>', methods=['GET'])
def get_team(team_id):
    """Get team details with all scores"""
    team = Team.query.get_or_404(team_id)
    
    team_data = team.to_dict()
    
    # Get all scores for this team, ordered by hole number
    scores = Score.query.filter_by(team_id=team_id).order_by(Score.hole_number).all()
    team_data['scores'] = [score.to_dict() for score in scores]
    team_data['total_score'] = team.get_total_score()
    team_data['relative_to_par'] = team.get_score_relative_to_par()
    team_data['locked_by_me'] = (
        team.is_locked and 
        team.locked_by == session.get('session_id')
    )
    
    return jsonify(team_data)


@app.route('/api/team/<int:team_id>/lock', methods=['POST'])
def lock_team(team_id):
    """Lock a team for editing"""
    check_and_release_expired_locks()
    
    team = Team.query.get_or_404(team_id)
    
    # Get or create session ID
    if 'session_id' not in session:
        session['session_id'] = secrets.token_hex(16)
    
    session_id = session['session_id']
    
    # Check if already locked by someone else
    if team.is_locked and team.locked_by != session_id:
        return jsonify({
            'success': False,
            'message': 'This team is currently being edited by another user.'
        }), 409
    
    # Lock the team
    team.is_locked = True
    team.locked_at = datetime.utcnow()
    team.locked_by = session_id
    
    db.session.commit()
    
    return jsonify({
        'success': True,
        'message': 'Team locked successfully',
        'team': team.to_dict()
    })


@app.route('/api/team/<int:team_id>/unlock', methods=['POST'])
def unlock_team(team_id):
    """Unlock a team"""
    team = Team.query.get_or_404(team_id)
    
    session_id = session.get('session_id')
    
    # Only allow unlocking if locked by this session or if force unlock
    force = request.json.get('force', False) if request.is_json else False
    
    if not force and team.is_locked and team.locked_by != session_id:
        return jsonify({
            'success': False,
            'message': 'You can only unlock teams that you have locked.'
        }), 403
    
    # Unlock the team
    team.is_locked = False
    team.locked_at = None
    team.locked_by = None
    
    db.session.commit()
    
    return jsonify({
        'success': True,
        'message': 'Team unlocked successfully',
        'team': team.to_dict()
    })


@app.route('/api/team/<int:team_id>/score', methods=['POST'])
def update_score(team_id):
    """Update score for a specific hole"""
    team = Team.query.get_or_404(team_id)
    
    session_id = session.get('session_id')
    
    # Verify team is locked by this session
    if not team.is_locked or team.locked_by != session_id:
        return jsonify({
            'success': False,
            'message': 'Team must be locked by you to update scores.'
        }), 403
    
    data = request.json
    hole_number = data.get('hole_number')
    strokes = data.get('strokes')
    
    if hole_number is None or not (1 <= hole_number <= 18):
        return jsonify({
            'success': False,
            'message': 'Invalid hole number. Must be between 1 and 18.'
        }), 400
    
    if strokes is not None and (strokes < 1 or strokes > 15):
        return jsonify({
            'success': False,
            'message': 'Invalid stroke count. Must be between 1 and 15.'
        }), 400
    
    # Find the score record
    score = Score.query.filter_by(team_id=team_id, hole_number=hole_number).first()
    
    if not score:
        return jsonify({
            'success': False,
            'message': 'Score record not found.'
        }), 404
    
    # Update the score
    score.strokes = strokes
    score.updated_at = datetime.utcnow()
    
    # Update team's lock timestamp to keep it active
    team.locked_at = datetime.utcnow()
    
    db.session.commit()
    
    return jsonify({
        'success': True,
        'message': 'Score updated successfully',
        'score': score.to_dict(),
        'total_score': team.get_total_score(),
        'relative_to_par': team.get_score_relative_to_par()
    })


@app.route('/api/course', methods=['GET'])
def get_course_info():
    """Get course information"""
    return jsonify({
        'name': COURSE_NAME,
        'pars': COURSE_PARS,
        'total_par': sum(COURSE_PARS),
        'holes': 18
    })


@app.route('/admin', methods=['GET', 'POST'])
def admin():
    """Admin panel with password protection"""
    if request.method == 'POST':
        password = request.form.get('password', '')
        admin_settings = AdminSettings.query.first()
        
        if admin_settings and password == admin_settings.password:
            session['admin_authenticated'] = True
            return redirect(url_for('admin'))
        else:
            return render_template('admin_login.html', error='Invalid password')
    
    # Check if already authenticated
    if not session.get('admin_authenticated'):
        return render_template('admin_login.html')
    
    return render_template('admin.html')


@app.route('/admin/logout')
def admin_logout():
    """Logout from admin panel"""
    session.pop('admin_authenticated', None)
    return redirect(url_for('index'))


@app.route('/api/admin/unlock-all', methods=['POST'])
def api_admin_unlock_all():
    """Unlock all teams (admin only)"""
    if not session.get('admin_authenticated'):
        return jsonify({'success': False, 'message': 'Unauthorized'}), 401
    
    try:
        locked_teams = Team.query.filter_by(is_locked=True).all()
        count = len(locked_teams)
        
        for team in locked_teams:
            team.is_locked = False
            team.locked_at = None
            team.locked_by = None
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'count': count,
            'message': f'Unlocked {count} team(s)'
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
