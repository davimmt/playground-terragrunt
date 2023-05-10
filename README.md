# terragrunt-playground

### How to
Just run

```bash
terragrunt run-all apply
```

### Notes
- The creation or association of subnet-related resources are linked to specific key value tags, that is:
    - NACL
    - RT (Route Table)
    - NGW (NAT Gateway)