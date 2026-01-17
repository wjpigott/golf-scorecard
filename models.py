from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

# Default course definition for Carlinville Country Club
COURSE_PARS = [4, 5, 4, 3, 4, 5, 3, 4, 4, 4, 5, 4, 3, 4, 5, 3, 4, 4]
COURSE_NAME = "Carlinville Country Club"


class Scramble(db.Model):
    __tablename__ = 'scrambles'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    date = db.Column(db.Date, nullable=False)
    course_name = db.Column(db.String(100), default=COURSE_NAME)
    is_active = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationship to teams
    teams = db.relationship('Team', backref='scramble', lazy=True, cascade='all, delete-orphan')
    
    def __repr__(self):
        return f'<Scramble {self.name} - {self.date}>'
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'date': self.date.isoformat() if self.date else None,
            'course_name': self.course_name,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'team_count': len(self.teams)
        }


class Team(db.Model):
    __tablename__ = 'teams'
    
    id = db.Column(db.Integer, primary_key=True)
    scramble_id = db.Column(db.Integer, db.ForeignKey('scrambles.id'), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    is_locked = db.Column(db.Boolean, default=False)
    locked_at = db.Column(db.DateTime, nullable=True)
    locked_by = db.Column(db.String(100), nullable=True)  # Session ID or identifier
    
    # Ensure team names are unique within a scramble
    __table_args__ = (db.UniqueConstraint('scramble_id', 'name', name='_scramble_team_uc'),)
    
    # Relationship to scores
    scores = db.relationship('Score', backref='team', lazy=True, cascade='all, delete-orphan')
    
    def __repr__(self):
        return f'<Team {self.name}>'
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'is_locked': self.is_locked,
            'locked_at': self.locked_at.isoformat() if self.locked_at else None,
            'locked_by': self.locked_by
        }
    
    def get_total_score(self):
        """Calculate total score for the team"""
        total = 0
        for score in self.scores:
            if score.strokes is not None:
                total += score.strokes
        return total
    
    def get_score_relative_to_par(self):
        """Calculate score relative to par (e.g., +5, -2, E)"""
        total_score = self.get_total_score()
        total_par = sum(COURSE_PARS)
        diff = total_score - total_par
        
        if diff == 0:
            return "E"
        elif diff > 0:
            return f"+{diff}"
        else:
            return str(diff)


class AdminSettings(db.Model):
    __tablename__ = 'admin_settings'
    
    id = db.Column(db.Integer, primary_key=True)
    password = db.Column(db.String(100), nullable=False)
    
    def __repr__(self):
        return f'<AdminSettings {self.id}>'


class Score(db.Model):
    __tablename__ = 'scores'
    
    id = db.Column(db.Integer, primary_key=True)
    team_id = db.Column(db.Integer, db.ForeignKey('teams.id'), nullable=False)
    hole_number = db.Column(db.Integer, nullable=False)  # 1-18
    strokes = db.Column(db.Integer, nullable=True)  # Actual strokes taken
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Ensure each team has only one score per hole
    __table_args__ = (db.UniqueConstraint('team_id', 'hole_number', name='_team_hole_uc'),)
    
    def __repr__(self):
        return f'<Score Team:{self.team_id} Hole:{self.hole_number} Strokes:{self.strokes}>'
    
    def to_dict(self):
        par = COURSE_PARS[self.hole_number - 1]
        relative_score = None
        if self.strokes is not None:
            diff = self.strokes - par
            if diff == 0:
                relative_score = "E"
            elif diff > 0:
                relative_score = f"+{diff}"
            else:
                relative_score = str(diff)
        
        return {
            'id': self.id,
            'team_id': self.team_id,
            'hole_number': self.hole_number,
            'strokes': self.strokes,
            'par': par,
            'relative_score': relative_score,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
