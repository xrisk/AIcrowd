import React from 'react';
import PropTypes from 'prop-types';

const Tooltip = ({ label, position, children }) => {
  return (
    <>
      <span aria-label={label} data-balloon-pos={position}>
        {children}
      </span>
    </>
  );
};

Tooltip.propTypes = {
  label: PropTypes.string,
  position: PropTypes.string,
  children: PropTypes.any,
};

export default Tooltip;
