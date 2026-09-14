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
COPY --chown=myuser:myuser "agents/weather_agent/" "/app/agents/weather_agent/"

# Copy agent - End

# Install Agent Deps - Start
RUN pip install -r "/app/agents/weather_agent/requirements.txt"
# Install Agent Deps - End

ENV PORT=8080
EXPOSE 8080

CMD exec adk web --port=${PORT} --host=0.0.0.0 "/app/agents"
