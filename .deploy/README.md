# Function Jenkins Deploy

This project assumes you have the following folder structure in your project:

```
.nvmrc
deploy
├── production-fn.json
├── test-fn.json
└── uat-fn.json
```

## Usage

To use put the following in before your first build step:

```
git clone git@github.com:brandsExclusive/infra-jenkins-up-deploy.git --depth 1 .deploy 2> /dev/null || (cd .deploy; git pull)
```

Then in the following build step run:

```
bash .deploy/deploy-jenkins.sh test
```

## Secrets

For secret variable add to your build step prefixed the `FN_`:

```
FN_MY_SECRET=V7NrMPpuNSWgA6rQ6ceZg4Af \
bash .deploy/deploy-jenkins.sh test
```

You process will now have access to `MY_SECRET`.

## E2E Checks

To enable e2e checks for production deployment use the circle token:

```
CIRCLE_TOKEN=cbcb816d4af1cc2142322f7a25fd45cxxxxxxx \
bash .deploy/deploy-jenkins.sh production
```
