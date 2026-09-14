FROM python:3.11-slim
WORKDIR /app

# Create a non-root user
RUN adduser --disabled-password --gecos "" myuser

# Switch to the non-root user
USER myuser

# Set up environment variables - Start
ENV PATH="/home/myuser/.local/bin:$PATH"

ENV GOOGLE_GENAI_USE_VERTEXAI=1
ENV GOOGLE_CLOUD_PROJECT=ai-agent-504412
ENV GOOGLE_CLOUD_LOCATION=us-west1

# Set up environment variables - End

# Install ADK - Start
RUN pip install google-adk==1.14.0
# Install ADK - End

# Copy agent - Start

# Set permission
COPY --chown=myuser:myuser "/weather_agent/agent" "/app/agents/weather_agent/"

# Copy agent - End

# Install Agent Deps - Start
RUN pip install -r "/app/agents/weather_agent/requirements.txt"
# Install Agent Deps - End

EXPOSE 8000

CMD adk web --port=8000 --host=0.0.0.0       "/app/agents"
