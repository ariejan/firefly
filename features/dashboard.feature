Feature:
    As a Firefly user
    I want to see my dashboard
    So I can get a quick overview of what's going on

    Scenario: Visit '/'
        When I visit the dashboard page
        Then I should see the dashboard
