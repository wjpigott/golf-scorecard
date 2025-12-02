"""
Golf Scramble Scorecard Application
====================================

This module provides helper utilities for the golf scorecard application.
"""

def calculate_handicap_score(gross_score, handicap, course_rating=72, slope_rating=113):
    """
    Calculate net score based on handicap (for future enhancement)
    
    Args:
        gross_score: The actual score shot
        handicap: Player/team handicap
        course_rating: Course rating (default 72)
        slope_rating: Slope rating (default 113)
    
    Returns:
        Net score after handicap adjustment
    """
    course_handicap = round(handicap * (slope_rating / 113))
    return gross_score - course_handicap


def format_score_display(score, par):
    """
    Format score for display with relative to par
    
    Args:
        score: Actual strokes taken
        par: Par for the hole
    
    Returns:
        Formatted string like "5 (+1)" or "3 (-1)" or "4 (E)"
    """
    if score is None:
        return "- (-)"
    
    diff = score - par
    if diff == 0:
        relative = "E"
    elif diff > 0:
        relative = f"+{diff}"
    else:
        relative = str(diff)
    
    return f"{score} ({relative})"


def validate_team_name(name):
    """
    Validate team name format
    
    Args:
        name: Team name to validate
    
    Returns:
        Boolean indicating if name is valid
    """
    if not name or not isinstance(name, str):
        return False
    
    # Allow Team1 through Team100
    if name.startswith("Team") and len(name) <= 7:
        try:
            num = int(name[4:])
            return 1 <= num <= 100
        except ValueError:
            return False
    
    return False


def get_hole_description(hole_number):
    """
    Get descriptive name for hole (for future enhancement)
    
    Args:
        hole_number: Hole number (1-18)
    
    Returns:
        String description of the hole
    """
    descriptions = {
        1: "Opening Hole",
        9: "Turn",
        10: "Back Nine Start",
        18: "Finishing Hole"
    }
    return descriptions.get(hole_number, f"Hole {hole_number}")


# Course constants
CARLINVILLE_CC = {
    'name': 'Carlinville Country Club',
    'holes': 18,
    'par': 72,
    'pars': [4, 5, 4, 3, 4, 5, 3, 4, 4, 4, 5, 4, 3, 4, 5, 3, 4, 4],
    'front_nine_par': 36,
    'back_nine_par': 36
}


if __name__ == '__main__':
    # Test utilities
    print("Golf Scorecard Utilities")
    print("=" * 50)
    print(f"\nCourse: {CARLINVILLE_CC['name']}")
    print(f"Par: {CARLINVILLE_CC['par']}")
    print(f"\nPar by hole:")
    for i, par in enumerate(CARLINVILLE_CC['pars'], 1):
        print(f"  Hole {i:2d}: Par {par}")
    
    print("\n" + "=" * 50)
    print("Example Score Displays:")
    print(f"  Par 4, shot 3: {format_score_display(3, 4)}")
    print(f"  Par 4, shot 4: {format_score_display(4, 4)}")
    print(f"  Par 4, shot 5: {format_score_display(5, 4)}")
    print(f"  Par 5, shot 7: {format_score_display(7, 5)}")
