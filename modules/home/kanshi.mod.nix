{
  config,
  lib,
  ...
}: let
  cfg = config.module.kanshi;
in {
  options.module.kanshi.enable = lib.mkEnableOption "Enable custom kanshi config";

  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      settings = [
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "AU Optronics 0x258C Unknown";
                status = "enable";
                mode = "1920x1080@60.05Hz";
                scale = 1.0;
                position = "0,0";
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office";
            outputs = [
              {
                criteria = "AU Optronics 0x258C Unknown";
                status = "enable";
                mode = "1920x1080@60.05Hz";
                scale = 1.0;
                position = "1920,120";
              }
              {
                criteria = "Dell Inc. DELL U2415 08DXD5C422HS";
                status = "enable";
                mode = "1920x1200@59.95Hz";
                scale = 1.0;
                position = "0,0";
              }
              {
                criteria = "Ancor Communications Inc VG248 F7LMQS100286";
                status = "enable";
                mode = "1920x1080@60.00Hz";
                scale = 1.0;
                position = "3840,120";
              }
              {
                criteria = "BNQ BenQ XL2420T P7C01529SL0";
                status = "enable";
                mode = "1920x1080@60.00Hz";
                transform = "90";
                scale = 1.0;
                position = "5760,0";
              }
            ];
          };
        }
        {
          profile = {
            name = "university_office";
            outputs = [
              {
                criteria = "AU Optronics 0x258C Unknown";
                status = "enable";
                mode = "1920x1080@60.05Hz";
                scale = 1.0;
                position = "1360,1440";
              }
              {
                criteria = "Dell Inc. DELL P2415Q D8VXF85208VL";
                status = "enable";
                mode = "3840x2160@29.98Hz";
                scale = 1.5;
                position = "0,0";
              }
              {
                criteria = "Iiyama North America PLX2481H 11358V6300583";
                status = "enable";
                mode = "1920x1080@60.00Hz";
                scale = 1.0;
                position = "2560,360";
              }
            ];
          };
        }
        {
          profile = {
            name = "assotiation_office";
            outputs = [
              {
                criteria = "AU Optronics 0x258C Unknown";
                status = "enable";
                mode = "1920x1080@60.05Hz";
                scale = 1.0;
                position = "723,1440";
              }
              {
                criteria = "HP Inc. HP P34hc G4 CNC3430KZ4";
                status = "enable";
                mode = "3440x1440@59.97Hz";
                scale = 1.0;
                position = "0,0";
              }
            ];
          };
        }
      ];
    };
  };
}
