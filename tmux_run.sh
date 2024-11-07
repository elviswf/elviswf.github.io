# crontab -e 
# @reboot /bin/bash /home/verit.dnv.com/admfanwu/admfanwu/code/llm/llm-report/tmux_run.sh

## Start TMUX session for monitoring ELK stack
tmux new-session -s llm -d zsh
## Start gpustat Service
tmux send-keys 'gpustat --watch' Enter
tmux split-window -v zsh


## Start xinference Service
tmux new-window -n embedding -t llm zsh
tmux send-keys 'conda activate py311' Enter
tmux send-keys 'CUDA_VISIBLE_DEVICES=2 xinference-local --host 0.0.0.0 --port 9997' Enter
tmux split-window -v zsh
tmux send-keys 'conda activate py311' Enter
tmux send-keys 'CUDA_VISIBLE_DEVICES=1 infinity_emb v2 --model-id BAAI/bge-m3' Enter

## Start dify Service
tmux new-window -n dify -t llm zsh
tmux send-keys 'cd /home/verit.dnv.com/admfanwu/admfanwu/code/github/dify/docker' Enter
tmux send-keys 'sudo podman-compose -f ./docker-compose.yaml down' Enter
tmux send-keys 'sudo podman-compose -f ./docker-compose.yaml up -d' Enter
tmux split-window -v zsh
tmux send-keys 'cd /home/verit.dnv.com/admfanwu/admfanwu/code/llm/llm-report' Enter
tmux send-keys 'hugo server --bind=0.0.0.0 -b osl4243' Enter


## Start ChatDNV API service
tmux new-window -n chatdnv -t llm zsh
# tmux send-keys 'cd /home/verit.dnv.com/admfanwu/code/data_science/nlp/lumina' Enter
# tmux send-keys 'uvicorn pdf_uploader:app --host 0.0.0.0 --port 8069' Enter
# tmux split-window -v bash
# tmux send-keys 'cd /home/verit.dnv.com/admfanwu/code/data_science/nlp/lumina' Enter
# tmux send-keys 'CUDA_VISIBLE_DEVICES=2 uvicorn embedding_api:app --host 10.128.136.2 --port 8067' Enter


## Start ChatDNV API service
#tmux new-window -n vllm -t llm
#tmux send-keys 'conda activate py311' Enter
#tmux send-keys 'CUDA_VISIBLE_DEVICES=0 python -m vllm.entrypoints.openai.api_server --model /mnt/sdb/nlp/hf_models/Meta-Llama-3-8B-Instruct --gpu-memory-utilization 0.8 --dtype=half' Enter
#tmux split-window -v bash
#tmux send-keys 'conda activate py311' Enter
#tmux send-keys 'cd /home/verit.dnv.com/admfanwu/code/data_science/nlp/llm/chatAgent' Enter
#tmux send-keys 'autogenstudio ui --port 8082 --host 0.0.0.0 --appdir ./data/autogen_dir' Enter


## corrosion
# /home/verit.dnv.com/admfanwu/code/vsts/web/coatingAI/AI
# CUDA_VISIBLE_DEVICES=1 uvicorn corrosion_api:app --host 10.128.136.2 --port 8081
## search
# /home/verit.dnv.com/admfanwu/code/vsts/web/search_api
# CUDA_VISIBLE_DEVICES=1 uvicorn search_fastapi:app --host 10.128.136.2 --port 8361
