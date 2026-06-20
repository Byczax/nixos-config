{
  config,
  lib,
  ...
}: let
  cfg = config.module.opencode;
in {
  options.module.opencode.enable = lib.mkEnableOption "Enable custom opencode config";

  config = lib.mkIf cfg.enable {
    age.secrets."opencode-api-key".file = "../system/secrets/opencode-api-key.age";
    programs.opencode = {
      enable = true;
      settings = {
        provider.ethz = {
          npm = "@ai-sdk/openai-compatible";
          name = "ETHZ LLM";
          options = {
            baseURL = "https://llm.vis.ethz.ch/v1";
            apiKey = "$(cat ${config.age.secrets."opencode-api-key".path})";
          };
          models = {
            "chatgpt/gpt-5.3-codex" = {};
            "chatgpt/gpt-5.3-codex-spark" = {};
            "chatgpt/gpt-5.3-instant" = {};
            "chatgpt/gpt-5.3-chat-latest" = {};
            "chatgpt/gpt-5.4" = {};
            "chatgpt/gpt-5.4-pro" = {};
          };
        };
        model = "ethz/chatgpt/gpt-5.4";
      };
      tui.theme = "system";
    };
  };
}
