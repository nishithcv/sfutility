Move-Item -Path configuration/pre-commit -Destination .git/hooks/
Move-Item -Path configuration/commit-msg -Destination .git/hooks/

if(Test-Path .git/hooks/pre-commit){
    echo "✅ SUCCESS: Pre Commit Hook Configured."
}

if(Test-Path .git/hooks/commit-msg){
    echo "✅ SUCCESS: Commit Message Hook Configured."
}

rmdir configuration -recurse