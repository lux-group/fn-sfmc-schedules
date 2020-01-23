const config = require(process.argv[2])
const vars = require("./vars")

const skeleton = {
  FunctionName: "",
  Role: "",
  Handler: "",
  Description: "",
  Timeout: 0,
  MemorySize: 0,
  VpcConfig: {
    SubnetIds: [],
    SecurityGroupIds: []
  },
  Environment: {
    Variables: {
      KeyName: ""
    }
  },
  Runtime: "go1.x",
  DeadLetterConfig: {
    TargetArn: ""
  },
  KMSKeyArn: "",
  TracingConfig: {
    Mode: "PassThrough"
  },
  RevisionId: "",
  Layers: []
}

// Remove unsuported
delete skeleton.Layers
delete skeleton.DeadLetterConfig

const newConfig = {
  ...skeleton,
  FunctionName: config.FunctionName,
  Role: config.Role,
  Handler: config.Handler,
  Description: config.Description,
  Timeout: config.Timeout,
  MemorySize: config.MemorySize,
  VpcConfig: config.VpcConfig,
  Environment: {
    Variables: {
      ...config.Environment.Variables,
      ...vars
    }
  },
  Runtime: config.Runtime
}

console.log(JSON.stringify(newConfig, null, 2))
