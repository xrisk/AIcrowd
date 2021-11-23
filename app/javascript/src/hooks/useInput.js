import { useState, useCallback } from 'react';

const useInput = (initValue = '') => {
  const [inputValue, setInputValue] = useState(initValue);

  const clearInput = useCallback(() => setInputValue(''), []);

  const handleInput = useCallback(
    e => {
      e.preventDefault();
      const { value } = e.target;
      setInputValue(value);
    },
    [setInputValue]
  );

  return { inputValue, handleInput, clearInput };
};

export default useInput;
