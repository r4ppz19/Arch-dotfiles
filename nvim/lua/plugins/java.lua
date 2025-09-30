return {
  "nvim-java/nvim-java",
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "MunifTanjim/nvim-lspconfig",
  },
  config = function()
    require("java").setup {
      spring = { enable = true },
      dap = { enable = true },
      test = { enable = true },
      root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
    }
  end,
}
