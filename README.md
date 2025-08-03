# FogNet-core

Simplify the launch and teardown of short-term computations in the cloud with a single Terraform module.

## 🚀 Problem

Many computation tasks require cloud resources that are powerful but expensive. Managing these instances efficiently — especially to avoid idle time — can be complex and error-prone.

## ✅ Solution

This Terraform module makes it easy to run computations on-demand using Ubuntu LTS-based cloud instances. It provides minimal setup, unified environment configuration, and automatic teardown after job completion — helping you avoid unnecessary costs and complexity.

## 🎯 Goals

- Lower the barrier for running short-term computation jobs in the cloud.
- Maximize cost-efficiency by eliminating idle time of compute resources.
- Offer consistent configuration across providers without requiring deep infrastructure knowledge.

## 🔑 Key Features

- ✅ Automatic mounting of S3-compatible buckets as local filesystems  
- ✅ Unified environment configuration — provider-agnostic setup  
- ✅ Simple shutdown mechanism after task completion  
  _(planned: automatic shutdown with notification and result output)_

## 💡 Use Cases

- Data-heavy processing tasks  
- Short-term server-side application execution (any language)

## 🧰 Requirements

- A cloud provider account (e.g., Yandex Cloud, AWS)  
- A configured environment file  
- A script that runs your computation on Ubuntu

## 🌐 Supported Providers

- ✅ Yandex Cloud  
- 🛠️ AWS
- 📋 Other providers are in the backlog

## ⚙️ Getting Started

1. Set up your cloud provider account  
2. Grant limited access permissions for this module  
3. Configure launch parameters  
4. Deploy with Terraform and run your job  

---

## Contributing

Contributions are welcome! If you have ideas, feedback, or want to collaborate, feel free to reach out via email: [astrelis.dev@gmail.com](mailto:astrelis.dev@gmail.com)

## Contact

For questions or suggestions, reach out to [astrelis.dev@gmail.com](mailto:astrelis.dev@gmail.com)

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## Support the Project

If you find FogNetKit useful, consider supporting its development:
[https://coff.ee/astrelis](https://coff.ee/astrelis)

## Project links

FogNet project [README](https://github.com/fognetkit/fognet-readme)

## Roadmap

- [ ] Improve leverage instructions 
- [ ] Create an example repository
- [ ] Automatic server shutdown when idle
- [ ] Multi-region deployment
- [ ] Automation support for `FogNet-manager` product