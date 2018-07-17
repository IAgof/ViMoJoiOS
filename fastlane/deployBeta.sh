branch_name=$(git symbolic-ref --short -q HEAD)
curl https://app.bitrise.io/app/1069a66c6544af04/build/start.json --data '{"hook_info":{"type":"bitrise","build_trigger_token":"zI1Jvn6nnORdp6FbKwnisw"},"build_params":{"branch":"'$branch_name'","workflow_id":"VimojoBetaFabric"},"triggered_by":"curl"}'
