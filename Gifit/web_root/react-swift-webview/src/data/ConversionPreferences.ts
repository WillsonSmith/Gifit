interface Settings {
  uri: string;
  fps: number;
  scale: number;
}

interface Kvp {
  key: string;
  value: number | string;
}

const conversionPreferenceStore = (() => {
  let settings: Settings = {
    uri: '',
    fps: 0,
    scale: 0,
  };

  return {
    get(key?: string): Settings {
      if (key) {
        return settings[key];
      }
      return settings;
    },
    set(options: Kvp) {
      const { key, value } = options;
      if (!key) { return; }
      return settings[key] = value;
    }
  };
})();

export default conversionPreferenceStore;
