const https = require('https')
const config = require(process.argv[2])
const environment = process.argv[3]
const token = process.argv[4]
const build = 'www-le-customer'

function runChecks() {
  if (environment !== 'production') {
    console.log(`skipping e2e check for ${config.name} (not a production release)`)
    process.exit(0)
  }

  if (!token) {
    console.log(`skipping e2e check for ${config.name} (no circleci token)`)
    process.exit(0)
  }

  return https.get({
    hostname: 'circleci.com',
    path: `/api/v1.1/project/github/brandsexclusive/${build}/tree/master?circle-token=${token}&filter=completed`,
    agent: false,
    headers: {
      accept: 'application/json'
    }
  }, (res) => {
    res.setEncoding('utf8');
    let rawData = '';
    res.on('data', (chunk) => { rawData += chunk; });
    res.on('end', () => {
      try {
        const parsedData = JSON.parse(rawData);
        const job = parsedData.find(x => x.build_parameters.CIRCLE_JOB === 'remote-e2e')
        if (job.status !== 'success') {
          console.log('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
          console.log('   deploy aborted due to failing remote-e2e build')
          console.log('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
          process.exit(1)
        }
        console.log('remote-e2e passing')
        process.exit(0)
      } catch (e) {
        console.error(e.message);
        process.exit(1)
      }
    });
  });
}

runChecks()
