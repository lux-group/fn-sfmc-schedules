const config = require(process.argv[2])

const vars = Object.keys(process.env).reduce((acc, key) => {
  const match = key.match(/^FN_(.+)/)
  return match ? acc.concat([[match[1], process.env[key]]]) : acc
}, [])

const newConfig = {
  ...config,
  Environment: {
    ...config.Environment,
    Variables: {
      ...config.Environment.Variables,
      ...vars.reduce((acc, v) => {
        acc[v[0]] = v[1]
        return acc
      }, {})
    }
  }
}

console.log(JSON.stringify(newConfig, null, 2))
