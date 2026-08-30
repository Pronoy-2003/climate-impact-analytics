import os
import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("OPENWEATHER_API_KEY")

WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"

AIR_QUALITY_URL = (
    "https://api.openweathermap.org/data/2.5/air_pollution"
)


def get_weather(latitude, longitude):

    params = {
        "lat": latitude,
        "lon": longitude,
        "appid": API_KEY,
        "units": "metric"
    }

    response = requests.get(
        WEATHER_URL,
        params=params,
        timeout=30
    )

    response.raise_for_status()

    return response.json()


def get_air_quality(latitude, longitude):

    params = {
        "lat": latitude,
        "lon": longitude,
        "appid": API_KEY
    }

    response = requests.get(
        AIR_QUALITY_URL,
        params=params,
        timeout=30
    )

    response.raise_for_status()

    return response.json()