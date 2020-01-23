const config = require(process.argv[2])
const vars = require("./vars")

const skeleton = {
  FunctionName: "",
  Runtime: "dotnetcore1.0",
  Role: "",
  Handler: "",
  Code: {
    ZipFile: null,
    S3Bucket: "",
    S3Key: "",
    S3ObjectVersion: ""
  },
  Description: "",
  Timeout: 0,
  MemorySize: 0,
  Publish: true,
  VpcConfig: {
    SubnetIds: [],
    SecurityGroupIds: []
  },
  DeadLetterConfig: {
    TargetArn: ""
  },
  Environment: {
    Variables: {
      KeyName: ""
    }
  },
  KMSKeyArn: "",
  TracingConfig: {
    Mode: "PassThrough"
  },
  Tags: {
    KeyName: ""
  },
  Layers: []
}

// Remove unsuported
delete skeleton.Layers
delete skeleton.DeadLetterConfig
delete skeleton.Code.S3Bucket
delete skeleton.Code.S3Key
delete skeleton.Code.S3ObjectVersion

const newConfig = {
  ...skeleton,
  ...config,
  Code: {
    ZipFile: "base64EncodedFile"
  },
  Environment: {
    Variables: {
      ...config.Environment.Variables,
      ...vars
    }
  }
}

console.log(JSON.stringify(newConfig, null, 2))
