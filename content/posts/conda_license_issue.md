+++
title = 'Conda_license_issue'
date = 2024-10-25T10:10:04+08:00
draft = true
+++

### License key points

1. Your registration, download, use, installation, access, or enjoyment of all Anaconda Offerings on behalf of an organization that has two hundred (200) or more employees or contractors (“Organizational Use”) requires a paid license of Anaconda Business or Anaconda Enterprise.[^1]

2. Miniconda is free for anyone to use! However, **access to Anaconda’s public repository** of packages is only free to individuals and small organizations (<200 employees). A paid license is required for larger organizations and anyone embedding or mirroring Anaconda’s repository.[^2]

### Recommened practice without a paid license of Anaconda Business or Anaconda Enterprise

1. Install miniconda only. 
2. Create a file ~/.condarc with the following contents:
```
channels:
  - conda-forge
```
You can check the active channels by running:
```
conda config --show channels
```

## Switch from Anaconda to Miniconda while preserving your existing environments

### 1. **Export Your Environments**

First, you'll need to export your existing environments from Anaconda. You can do this using the `conda env export` command for each environment.

Open your terminal (or Anaconda Prompt) and run:

```bash
conda activate your_env_name
conda env export > your_env_name.yml
```

Repeat this for all your environments.

### 2. **Install Miniconda**

1. **Uninstall Anaconda**: Before installing Miniconda, uninstall Anaconda from your system. Make sure to back up any important data.
   
2. **Download Miniconda**: Go to the [Miniconda website](https://docs.conda.io/en/latest/miniconda.html) and download the installer for your operating system.

3. **Install Miniconda**: Follow the installation instructions provided on the website.
```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```

### 3. **Recreate Your Environments in Miniconda**

Once Miniconda is installed, you can recreate your environments using the YAML files you exported earlier.

For each environment, run:

```bash
conda env create -f your_env_name.yml
```

### 4. **Verify the Installation**

After recreating your environments, you can activate them to ensure everything works as expected:

```bash
conda activate your_env_name
```

### 5. **Cleanup**

Once you’ve confirmed that your environments are working correctly in Miniconda, you can delete the YAML files if you no longer need them.

### Summary

1. Export your environments from Anaconda.
2. Uninstall Anaconda.
3. Install Miniconda.
4. Recreate your environments using the exported files.
5. Verify and clean up.

If you have any questions or run into issues, feel free to ask!


### Reference

[^1]: anaconda license: https://legal.anaconda.com/policies/en/?name=terms-of-service#anaconda-terms-of-service
[^2]: miniconda license: https://docs.anaconda.com/miniconda/
