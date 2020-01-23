const vars = Object.keys(process.env).reduce((acc, key) => {
  const match = key.match(/^FN_(.+)/)
  return match ? acc.concat([[match[1], process.env[key]]]) : acc
}, [])

module.exports = vars.reduce((acc, v) => {
  acc[v[0]] = v[1]
  return acc
}, {})
