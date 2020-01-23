const config = require(process.argv[2])

const skeleton = {
  FunctionName: "",
  ZipFile: "base64EncodedFile",
  S3Bucket: "",
  S3Key: "",
  S3ObjectVersion: "",
  Publish: true,
  DryRun: true,
  RevisionId: ""
}

// Remove unsuported
delete skeleton.S3Bucket
delete skeleton.S3Key
delete skeleton.S3ObjectVersion
delete skeleton.DryRun

const newConfig = {
  ...skeleton,
  FunctionName: config.FunctionName
}

console.log(JSON.stringify(newConfig, null, 2))
