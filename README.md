<!-- llm-readme-management spec=1 commit=1eab02b29c4924988e968035a9ec23e2858392c8 template=default model=qwen3.6-35b-a3b digest=598d66067ca0 generated=2026-09-08T22:50:40Z -->
<a href="https://hauke.cloud" target="_blank"><img src="https://img.shields.io/badge/home-hauke.cloud-brightgreen" alt="hauke.cloud" style="display: block;" /></a>
<a href="https://github.com/hauke-cloud" target="_blank"><img src="https://img.shields.io/badge/github-hauke.cloud-blue" alt="hauke.cloud Github Organisation" style="display: block;" /></a>
<a href="https://github.com/hauke-cloud/llm-readme-management" target="_blank"><img src="https://img.shields.io/badge/template-default-orange" alt="Repository type - default" style="display: block;" /></a>


# Pre Commit Oci Packages


<img src="https://raw.githubusercontent.com/hauke-cloud/.github/main/resources/img/organisation-logo-small.png" alt="hauke.cloud logo" width="109" height="123" align="right">


<llm header>

This repository contains a Bash script that parses Git tags and extracts package versions into a formatted README section. You can run it as part of your pre-commit pipeline to automatically document OCI or Docker container image packages for operators and developers.

</llm>


## :book: Description

<llm description>

This repository provides a pre-commit hook concept for documenting package versions installed in container images. If you run pre-commit in your pipelines and need to track software versions across OCI or Docker deployments, this tool automates that documentation. It reads git tags, parses semantic versioning components, and manages a dedicated section in your README file between custom comment markers.

The repository includes a bash script and a YAML data file for mapping version tiers to specific releases of opentofu, terraform, and vault. You can configure the workflow using command-line flags or environment variables.

Key capabilities include:
- Parsing git tags to determine current package versions
- Extracting content between `<!-- BEGIN_PACKAGES -->` and `<!-- END_PACKAGES -->` markers in a README
- Maintaining a version-tier mapping file for infrastructure tools
- Configuring base versions, target files, and tag patterns via flags or environment variables

</llm>


## 🚀 Getting started

<llm getting_started hint="Assume nothing about the ecosystem beyond what the analysis names. If the repository has no build step, say what a reader does with it instead.">

1. Clone the repository and enter its directory.
```bash
git clone https://github.com/hauke-cloud/pre-commit-oci-packages.git
cd pre-commit-oci-packages
```
2. Run the script with a base version to bypass missing git tags.
```bash
bash document-packages.sh -b 0.0.1
```
3. Pass the path to your documentation file using the readme flag.
```bash
bash document-packages.sh -r README.md
```

</llm>


## :airplane: Usage

<llm usage>

You run the repository as a standalone Bash script. Execution requires `git` on your `$PATH` and a target README file containing `<!-- BEGIN_PACKAGES -->` and `<!-- END_PACKAGES -->` markers. You configure behavior through CLI flags or environment variables, all of which provide defaults.

To execute the script with explicit options, pass the desired parameters directly to `document-packages.sh`. For example, you can specify a base version, target a custom README file, and define a custom section header:
```bash
bash document-packages.sh -b 0.0.0 -r README.md -s PACKAGES
```

Alternatively, you can control the script's execution by exporting environment variables before running it. This approach is useful when integrating the script into shell scripts or CI pipelines:
```bash
export BASE_VERSION=0.0.0 README_FILE=README.md SECTION_HEADER=PACKAGES
bash document-packages.sh
```

The script reads the latest git tag matching the `VERSION_PATTERN` (default `^v?([0-9]+)\.([0-9]+)\.([0-9]+)$`) to determine versioning, or falls back to the provided `BASE_VERSION`. Note that the current implementation reads the content between the markers but does not write updated values back to the file.

</llm>


## 📄 License

This Project is licensed under the GNU General Public License v3.0

- see the [LICENSE](LICENSE) file for details.


## :coffee: Contributing

To become a contributor, please check out the [CONTRIBUTING](CONTRIBUTING.md) file.


## :email: Contact

For any inquiries or support requests, please open an issue in this
repository or contact us at [contact@hauke.cloud](mailto:contact@hauke.cloud).
