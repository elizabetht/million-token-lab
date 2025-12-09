#!/usr/bin/env python3
import json
import os
from datetime import datetime

data = {
    'model': os.getenv('MODEL', ''),
    'dgx_cost_per_hour': float(os.getenv('DGX_COST', '0')),
    'image_tag': os.getenv('FULL_IMAGE', ''),
    'prefill': {
        'tokens_per_second': float(os.getenv('INPUT_TPS', '0')),
        'cost_per_million_tokens': float(os.getenv('COST_IN', '0'))
    },
    'cached': {
        'tokens_per_second': float(os.getenv('CACHED_TPS', '0')),
        'cost_per_million_tokens': float(os.getenv('COST_CACHED', '0'))
    },
    'decode': {
        'tokens_per_second': float(os.getenv('OUTPUT_TPS', '0')),
        'cost_per_million_tokens': float(os.getenv('COST_OUT', '0'))
    },
    'timestamp': datetime.utcnow().isoformat() + 'Z',
    'vllm_server_args': {
        'gpu_memory_utilization': 0.3,
        'max_model_len': 131072,
        'kv_transfer_config': {
            'kv_connector': 'LMCacheConnectorV1',
            'kv_role': 'kv_both'
        },
        'prefix_caching': False
    },
    'lmcache_config': {
        'enabled': True,
        'chunk_size': 8,
        'local_cpu': True,
        'max_local_cpu_size': 5.0
    },
    'benchmark_args': {
        'prefill_test': {
            'num_prompts': 100,
            'request_rate': 10,
            'input_len': 3072,
            'output_len': 1024,
            'ratio': '3:1 input:output',
            'total_tokens': 4096
        },
        'decode_test': {
            'num_prompts': 100,
            'request_rate': 10,
            'input_len': 1024,
            'output_len': 3072,
            'ratio': '1:3 input:output',
            'total_tokens': 4096
        }
    },
    'hardware': {
        'platform': 'NVIDIA DGX Spark',
        'gpu': 'Grace Hopper',
        'architecture': 'ARM64'
    }
}

with open('bench_results.json', 'w') as f:
    json.dump(data, f, indent=2)

print(json.dumps(data, indent=2))
