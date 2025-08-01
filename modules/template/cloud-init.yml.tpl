#cloud-config
package_update: true
package_upgrade: false

packages:
%{ for pkg in packages ~}
  - ${pkg}
%{ endfor ~}

%{ if mount_bucket.enabled == true ~}
write_files:
  - path: /root/.passwd-s3fs
    permissions: '0600'
    owner: root:root
    content: |
      ${bucket_props.access_key}:${bucket_props.secret_key}
%{ endif ~}

runcmd:
%{ if mount_bucket.enabled == true ~}
  - mkdir ${mount_bucket.path}
  - s3fs ${bucket_props.bucket} ${mount_bucket.path} -o passwd_file=/root/.passwd-s3fs -o url=${bucket_props.server} ${bucket_props.path_request_style ? "-o use_path_request_style" : ""} -o allow_other
%{ endif ~}
%{ for cmd in run_commands ~}
  - ${cmd}
%{ endfor ~}

final_message: "✅ cloud-init done"