from models import db, Team, Score, AdminSettings, COURSE_PARS
from flask import Flask
import os

def init_database():
    """Initialize the database with teams and empty scores"""
    
    # Create Flask app for database initialization
    app = Flask(__name__)
    
    # Configure SQLite database
    basedir = os.path.abspath(os.path.dirname(__file__))
    app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{os.path.join(basedir, "golf_scramble.db")}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    
    # Initialize database
    db.init_app(app)
    
    with app.app_context():
        # Drop all tables and recreate (fresh start)
        db.drop_all()
        db.create_all()
        
        print("Database tables created successfully!")
        
        # Create 100 teams
        teams_created = 0
        for i in range(1, 101):
            team = Team(name=f"Team{i}")
            db.session.add(team)
            teams_created += 1
        
        db.session.commit()
        print(f"Created {teams_created} teams (Team1 - Team100)")
        
        # Create empty score records for each team and hole
        scores_created = 0
        teams = Team.query.all()
        for team in teams:
            for hole_num in range(1, 19):  # Holes 1-18
                score = Score(
                    team_id=team.id,
                    hole_number=hole_num,
                    strokes=None  # Start with no score
                )
                db.session.add(score)
                scores_created += 1
        
        db.session.commit()
        print(f"Created {scores_created} score records (100 teams × 18 holes)")
        
        # Create admin settings with default password
        admin = AdminSettings(password="golf")
        db.session.add(admin)
        db.session.commit()
        print("Created admin settings with password: 'golf'")
        
        print("\n✓ Database initialization complete!")
        print(f"  - Course: Carlinville Country Club")
        print(f"  - Par: {sum(COURSE_PARS)} (18 holes)")
        print(f"  - Teams: 100")
        print(f"  - Admin password: golf")
        print(f"\nDatabase file: {os.path.join(basedir, 'golf_scramble.db')}")

if __name__ == '__main__':
    init_database()
