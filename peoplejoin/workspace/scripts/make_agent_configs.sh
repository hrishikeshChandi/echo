#!/bin/bash

# Usage: bash make_agent_configs.sh <model_name>
# Example: bash make_agent_configs.sh Qwen/Qwen2.5-7B-Instruct

MODEL=$1

if [ -z "$MODEL" ]; then
    echo "Error: No model name provided"
    echo "Usage: bash make_agent_configs.sh <model_name>"
    echo "Example: bash make_agent_configs.sh Qwen/Qwen2.5-7B-Instruct"
    exit 1
fi

echo "Generating agent configs for model: $MODEL"

CONFIG_DIR=workspace/peoplejoin-qa/experiments/agent_configs

# Ensure the config directory exists
mkdir -p "$CONFIG_DIR"

# Automatically detect tasks from a predefined list
TASKS=(department_store coffee_shop student_assessment wedding election)

for task in "${TASKS[@]}"; do
    cat > "$CONFIG_DIR/agentconf_${task}_gpt4o_oneexample.json" << JSONEOF
{
    "main_user_id": "alice",
    "tenant_id": "tenant_data_v2/${task}",
    "model_config": {
        "model": "${MODEL}"
    },
    "exemplar_ids": [
        "peoplejoinqa_1"
    ],
    "plugin_ids": [
        "system",
        "enterprise",
        "enterprise_search",
        "cot"
    ]
}
JSONEOF

    echo "✅ Created agentconf_${task}_gpt4o_oneexample.json"
done

echo ""
echo "All ${#TASKS[@]} configs generated for model: $MODEL"
