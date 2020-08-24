module.exports = function(config) {
  config.set({
    mutator: "javascript",
    packageManager: "npm",
    reporters: ["clear-text", "dots"],
    testRunner: "jest",
    coverageAnalysis: "off",
    tempDirName: "stryker-tmp",
    files: ["src/**"]
  });
};
