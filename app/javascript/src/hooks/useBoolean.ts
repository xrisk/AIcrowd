import { useState, useCallback } from 'react';

const useBoolean = (initValue = false) => {
  const [value, setValue] = useState(initValue);

  const toggle = useCallback(() => setValue(!value), [value]);
  return { value, toggle, setValue };
};

export default useBoolean;
