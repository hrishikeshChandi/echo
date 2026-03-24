agent=$1
model=$2
benchmark=$3

# bash scripts/run.sh echo dev-gpt-4o-2024-05-13 small-1m

# We used seeds 0-5 for prompt tuning, so we test on 6-16.

for env_id in $(seq 6 16); do

    # seed advances the iteration
    for seed in $(seq 0 16); do
        uv run python run.py --seed $seed --num-trials 1  --benchmark-id $benchmark --agent-type react --hindsight-type $agent --save-dir results/$benchmark/$model/$agent/$seed --model $model --ruleset-id $env_id --llm-backend vllm

        uv run python offline_compute.py --run-dir results/$benchmark/$model/$agent/ --trial-file results_${seed}.json --model $agent
    done
done


# ---------------------- manual control

# uv run python manual_control.py --env-id "XLand-MiniGrid"