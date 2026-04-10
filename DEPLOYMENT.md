# Deployment Guide

## Environment

- OS: Linux (Ubuntu)
- Python: 3.10+
- Virtual Environment: `.venv/`

## Installation Steps

### 1. Create Virtual Environment & Install Dependencies

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 2. Configure Environment Variables

Copy template and edit:

```bash
cp .env.example .env
```

#### AI Model (Azure OpenAI)

Using LiteLLM YAML config for Azure OpenAI:

- `.env` settings:
  ```
  LITELLM_CONFIG=./litellm_config.yaml
  LITELLM_MODEL=gpt-5.4
  AZURE_API_KEY=<your-azure-api-key>
  LITELLM_LOG=ERROR
  ```

- `litellm_config.yaml`:
  ```yaml
  model_list:
    - model_name: gpt-5.4
      litellm_params:
        model: azure/gpt-5.4
        api_base: https://<your-resource>.openai.azure.com/
        api_key: os.environ/AZURE_API_KEY
        api_version: "2025-04-01-preview"
  ```

> Note: The project's channel config (`LLM_CHANNELS`) does not natively support Azure's required `api_version` parameter. Use the YAML config method instead.

#### Search Engines

```
ANSPIRE_API_KEYS=<key>
TAVILY_API_KEYS=<key>
BOCHA_API_KEYS=<key>
```

#### Data Source

```
TICKFLOW_API_KEY=<key>
```

#### Web UI

```
WEBUI_HOST=0.0.0.0
WEBUI_PORT=8000
ADMIN_AUTH_ENABLED=true
```

### 3. Run

#### Foreground

```bash
source .venv/bin/activate
python main.py --serve          # Web + run analysis once on start
python main.py --serve-only     # Web only, no auto analysis
python main.py --serve --schedule  # Web + daily scheduled analysis
```

#### Background

```bash
bash start.sh   # Start in background
bash stop.sh    # Stop service
```

#### CLI Options

```bash
python main.py --stocks 600519,hk00700,AAPL   # Specify stocks
python main.py --market-review                  # Market review only
python main.py --debug                          # Debug mode
```

### 4. Access

- LAN: `http://<server-ip>:8000`
- First visit will prompt for admin password setup (when `ADMIN_AUTH_ENABLED=true`)
- Forgot password: `python -m src.auth reset_password`

## Run Modes

| Command | Behavior |
|---------|----------|
| `--serve` | Start Web + run analysis once immediately |
| `--serve-only` | Start Web only, trigger analysis from UI |
| `--schedule` | Daily scheduled analysis at `SCHEDULE_TIME` (default 18:00) |
| `--serve --schedule` | Web + daily scheduled analysis |

## Logs

Logs are stored in `logs/` with automatic rotation:

| File | Max Size | Backups | Total Cap |
|------|----------|---------|-----------|
| app.log | 10MB | 5 | ~60MB |
| debug.log | 50MB | 3 | ~200MB |

No manual cleanup needed.

## Files Modified/Created During Deployment

| File | Description |
|------|-------------|
| `.env` | Runtime config (git-ignored) |
| `litellm_config.yaml` | Azure OpenAI model routing |
| `start.sh` | Background start script |
| `stop.sh` | Stop script |
| `DEPLOYMENT.md` | This document |
