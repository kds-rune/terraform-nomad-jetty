output "rendered" {
  description = "Rendered Nomad jobspec(s)"
  value = nomad_job.JOB.jobspec
}
