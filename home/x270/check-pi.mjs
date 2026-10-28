import { homedir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

// Use exactly the resource loader shipped with Satellite's pinned Pi.
const root = join(homedir(), "develop/kaname-ai-satellite");
const loaderUrl = pathToFileURL(join(root,
  "node_modules/@earendil-works/pi-coding-agent/dist/core/resource-loader.js"));
const { DefaultResourceLoader } = await import(loaderUrl.href);
const loader = new DefaultResourceLoader({
  cwd: join(homedir(), "Workspace"),
  agentDir: process.env.PI_CODING_AGENT_DIR || join(homedir(), ".pi/agent"),
  noSkills: true,
  noContextFiles: true,
});
await loader.reload();
const result = loader.getExtensions();
const extensions = result.extensions.map(extension => ({
  path: extension.path,
  tools: [...extension.tools.keys()],
}));
const computerUseLoaded = extensions.some(extension =>
  extension.tools.includes("computer_use_linux_tools"));
console.log(JSON.stringify({ computerUseLoaded, extensions, errors: result.errors }, null, 2));
process.exitCode = result.errors.length || !computerUseLoaded ? 1 : 0;
