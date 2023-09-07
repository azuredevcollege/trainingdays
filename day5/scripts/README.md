# Using enable-workflows-for.sh on your repository

1. Create an (empty) repository named `trainingdays` on your own github account.
2. Open a bash in a cloned copy of the `azuredevcollege/trainingdays`
3. Make sure you have no uncommited changes.
4. Navigate to `trainingdays/day/scripts`.
5. Mark the `enable-workflows-for.sh` as executable: `chmod +x enable-workflows-for.sh`
6. Run the `enable-workflows-for.sh` with you username as argument, e.g.: `enable-workflows-for.sh waeltken`
7. Follow the instructions printed by the script to set your GitHub Secrets on that repository.
8. Deploy all pipelines starting with the infrastructure one.
9. Continue with day5!
