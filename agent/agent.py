import requests

from google.adk.agents import Agent


WEATHER_API_URL = "https://api.weatherapi.com/v1/current.json"


def get_weather(city: str) -> dict:
    """
    Get current weather information for a city.

    Args:
        city: Name of the city, e.g. "London" or "Almaty".

    Returns:
        Current weather information.
    """
    api_key = "d62a2e6967b2474bb7b60835261208"

    if not api_key:
        return {
            "error": "WEATHER_API_KEY environment variable is not configured."
        }

    try:
        response = requests.get(
            WEATHER_API_URL,
            params={
                "key": api_key,
                "q": city,
            },
            timeout=10,
        )

        response.raise_for_status()

        data = response.json()

        return {
            "city": data["location"]["name"],
            "country": data["location"]["country"],
            "temperature_c": data["current"]["temp_c"],
            "feels_like_c": data["current"]["feelslike_c"],
            "condition": data["current"]["condition"]["text"],
            "humidity": data["current"]["humidity"],
            "wind_kph": data["current"]["wind_kph"],
        }

    except requests.RequestException as e:
        return {
            "error": f"Failed to retrieve weather data: {str(e)}"
        }


root_agent = Agent(
    name="weather_agent",
    model="gemini-2.5-flash",
    description="An AI agent that provides current weather information.",
    instruction="""
    You are a helpful weather assistant.

    When the user asks about the current weather:
    1. Identify the city from the user's request.
    2. Call the get_weather tool with that city.
    3. Use the tool result to answer the user.
    4. Do not invent weather information.
    5. If the city is not specified, ask the user which city they mean.
    6. Present the temperature in Celsius.
    """,
    tools=[get_weather],
)
