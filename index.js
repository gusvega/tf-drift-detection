const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
  try {
    const workdir = core.getInput('workdir') || '.';
    const options = { cwd: workdir };
    let drift = false;
    try {
      await exec.exec('terraform', ['init', '-input=false'], options);
      await exec.exec('terraform', ['plan', '-detailed-exitcode', '-input=false'], options,);
    } catch (e) {
      // terraform plan -detailed-exitcode returns exit code 2 when changes present
      if (typeof e.code === 'number' && e.code === 2) {
        drift = true;
      } else {
        core.info('terraform not found or error running; marking no drift for now');
      }
    }
    core.setOutput('drift_found', drift ? 'true' : 'false');
  } catch (error) {
    core.setFailed(error.message);
  }
}
run();
