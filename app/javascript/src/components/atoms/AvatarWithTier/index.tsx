import React from 'react';
import Skeleton from 'react-loading-skeleton';

import styles from './avatarWithTier.module.scss';
const { onCardAvatar } = styles;

export type AvatarWithTierProps = {
  id?: number;
  tier: number;
  image: string;
  loading: boolean;
  size?: 'sm' | 'lg' | 'md' | 'ml';
  onCard?: boolean;
  borderColor?: string;
};

const AvatarWithTier = ({ tier, image, size, loading, onCard, borderColor }: AvatarWithTierProps) => {
  if (onCard) {
    return (
      <>
        {loading ? (
          <div>
            <Skeleton circle={true} width={23} height={23} />
          </div>
        ) : (
          <div style={{ width: '32px' }}>
            <img className={onCardAvatar} src={image} alt="User avatar" style={{ borderColor: borderColor }}></img>
          </div>
        )}
      </>
    );
  } else {
    return (
      <>
        {loading ? (
          <div>
            <Skeleton circle={true} width={34} height={34} />
          </div>
        ) : (
          <div className={`${styles[`user-rating-${tier}`]} ${styles[size ? `user-rating-${size}` : 'user-rating']}`}>
            <img className={styles.avatar} src={image} alt="User avatar"></img>
          </div>
        )}
      </>
    );
  }
};
export default AvatarWithTier;
