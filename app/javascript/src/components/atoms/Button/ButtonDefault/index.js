import React, { useState, useCallback } from 'react';
import { motion } from 'framer-motion';
import PropTypes from 'prop-types';

import styles from './buttonDefault.module.scss';

const ButtonDefault = ({
  type,
  text,
  disabled,
  hidden,
  iconClass,
  handleClick,
  size,
  iconColor,
  fontWeight,
  paddingRight,
  paddingTop,
  paddingBottom,
  paddingLeft,
  hoverBorder,
  iconLeft,
  iconSize,
  transparent,
  buttonType,
  disableAnimation,
  fontSize,
  fontFamily,
}) => {
  const [hoverStyle, setHoverStyle] = useState({
    border: null,
  });

  const handleMouseEnter = useCallback(() => {
    setHoverStyle({
      border: hoverBorder,
    });
  }, [setHoverStyle, hoverBorder]);
  const handleMouseLeave = useCallback(() => {
    setHoverStyle({
      border: null,
    });
  }, [setHoverStyle]);

  const largeButton = size === 'large' ? styles.large : '';
  const wideButton = size === 'wide' ? styles.wide : '';

  // Do not show button if hidden is true
  if (hidden) {
    return <></>;
  }
  return (
    <>
      {/* Show button with icon */}
      {iconClass && iconClass.length > 0 ? (
        <>
          <button
            // eslint-disable-next-line react/button-has-type
            type={buttonType}
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
            className={`${styles[`btn-${type}`]} ${largeButton} ${wideButton}`}
            disabled={disabled}
            whileTap={{ scale: disableAnimation ? 1 : 0.98 }}
            layout="position"
            style={{
              fontWeight: fontWeight,
              paddingRight: paddingRight,
              paddingLeft: paddingLeft,
              paddingTop: paddingTop,
              paddingBottom: paddingBottom,
              border: hoverStyle.border,
              flexDirection: iconLeft && 'row-reverse',
              background: transparent && 'transparent',
              fontSize,
              fontFamily,
            }}
            onClick={handleClick}>
            {text}
            &nbsp;
            <i
              className={`las la-${iconClass}`}
              style={{
                color: iconColor,
                paddingRight: iconLeft && '8px',
                paddingLeft: iconLeft && '0px',
                fontSize: iconSize,
              }}
            />
          </button>
        </>
      ) : (
        <button
          // eslint-disable-next-line react/button-has-type
          type={buttonType}
          className={`${styles[`btn-${type}`]} ${largeButton} ${wideButton}`}
          disabled={disabled}
          onClick={handleClick}
          whileTap={{ scale: disableAnimation ? 1 : 0.98 }}
          layout="position"
          style={{
            fontWeight: fontWeight,
            paddingRight: paddingRight,
            paddingLeft: paddingLeft,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            border: hoverStyle.border,
            flexDirection: iconLeft && 'row-reverse',
            background: transparent && 'transparent',
            fontSize,
            fontFamily,
          }}>
          {text}
        </button>
      )}
    </>
  );
};

ButtonDefault.propTypes = {
  type: PropTypes.string,
  text: PropTypes.string.isRequired,
  disabled: PropTypes.bool,
  hidden: PropTypes.bool,
  iconClass: PropTypes.string,
  handleClick: PropTypes.func,
  size: PropTypes.string,
  iconColor: PropTypes.string,
  fontWeight: PropTypes.string,
  paddingRight: PropTypes.string,
  paddingTop: PropTypes.string,
  paddingBottom: PropTypes.string,
  paddingLeft: PropTypes.string,
  hoverBorder: PropTypes.string,
  iconLeft: PropTypes.bool,
  iconSize: PropTypes.string,
  transparent: PropTypes.bool,
  buttonType: PropTypes.string,
  fontSize: PropTypes.string,
  disableAnimation: PropTypes.bool,
  fontFamily: PropTypes.string,
};

export default ButtonDefault;
