import React from 'react';
import Link from 'next/link';
import classnames from 'classnames';

import styles from './aicrowdLogo.module.scss';
const { logomark, brand, logoText, aiText, text } = styles;

export type AicrowdLogoProps =
  | {
      type: 'mark' | 'text';
      size: number;
      fontFamily?: string;
      fontWeight?: number;
    }
  | {
      type: 'full';
      size?: never;
      fontFamily?: never;
      fontWeight?: never;
    };

const AicrowdLogo = ({ type, size, fontFamily, fontWeight }: AicrowdLogoProps) => {
  const isFull = type === 'full';
  const isMark = type === 'mark';
  const isText = type === 'text';
  return (
    <>
      <Link href="/">
        <a
          className={classnames({ [brand]: isFull, [logomark]: isMark, [text]: isText })}
          style={{ width: isMark && `${size}px`, height: isMark && `${size}px` }}>
          {type === 'text' && (
            <span className={logoText}>
              <span className={aiText} style={{ fontSize: `${size}px`, fontFamily, fontWeight }}>
                AI
              </span>
              <span style={{ fontSize: `${size}px`, fontFamily, fontWeight, color: '#1f1f1f' }}>crowd</span>
            </span>
          )}
        </a>
      </Link>
    </>
  );
};

export default AicrowdLogo;
