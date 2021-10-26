# terraform-nomad-templatejob
[Nomad job via Terraform templating](https://github.com/Kreditorforeningens-Driftssentral-DA/terraform-nomad-templatejob)

## HOW TO USE
  * The resource "nomad_job" creates a job from a template. This template uses variable to populate the settings for name & groups.
  * Each task is added as a base64-encoded string for the group(s), and is pre-rendered with its own parameters using templatefile.

See example