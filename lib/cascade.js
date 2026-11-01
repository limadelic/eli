const off = (id) => ({ id, max: Infinity });

const limits = {
  string: (id) => off(id),
  object: (id, [severity, { max }]) => ({ id, severity, max }),
};

export const cascade = (keys, settings, fallback) =>
  keys
    .filter((key) => key in settings)
    .map((id) => limits[typeof settings[id]](id, settings[id]))
    .concat(fallback)[0];

export { off };
