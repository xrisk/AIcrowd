import React, { useState, useCallback } from 'react';
import { motion } from 'framer-motion';

import styles from './buttonDefault.module.scss';

export type ButtonDefaultProps = {
  type: string;
  text: string;
  disabled?: boolean;
  hidden?: boolean;
  iconClass?: string;
  handleClick?: any;
  size?: 'large' | 'wide';
  iconColor?: string;
  fontWeight?: any;
  paddingRight?: string;
  paddingLeft?: string;
  paddingTop?: string;
  paddingBottom?: string;
  hoverBorder?: string;
  iconLeft?: boolean;
  iconSize?: string;
  transparent?: boolean;
  buttonType?: 'button' | 'submit';
  disableAnimation?: boolean;
  fontSize?: string;
  fontFamily?: string;
  justifyContent?: string;
};

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
  justifyContent,
}: ButtonDefaultProps) => {
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
        <motion.button
          // eslint-disable-next-line react/button-has-type
          type={buttonType}
          onMouseEnter={handleMouseEnter}
          onMouseLeave={handleMouseLeave}
          className={`${styles[`btn-${type}`]} ${largeButton} ${wideButton}`}
          disabled={disabled}
          whileTap={{ scale: disableAnimation ? 1 : 0.98 }}
          style={{
            fontWeight: fontWeight,
            paddingRight: paddingRight,
            paddingLeft: paddingLeft,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            border: hoverStyle.border,
            flexDirection: iconLeft ? 'row-reverse' : 'row',
            background: transparent && 'transparent',
            fontSize,
            fontFamily,
            justifyContent,
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
        </motion.button>
      ) : (
        <motion.button
          // eslint-disable-next-line react/button-has-type
          type={buttonType}
          className={`${styles[`btn-${type}`]} ${largeButton} ${wideButton}`}
          disabled={disabled}
          onClick={handleClick}
          whileTap={{ scale: disableAnimation ? 1 : 0.98 }}
          style={{
            fontWeight: fontWeight,
            paddingRight: paddingRight,
            paddingLeft: paddingLeft,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            border: hoverStyle.border,
            flexDirection: iconLeft ? 'row-reverse' : 'row',
            background: transparent && 'transparent',
            fontSize,
            fontFamily,
            justifyContent,
          }}>
          {text}
        </motion.button>
      )}
    </>
  );
};

export default ButtonDefault;
