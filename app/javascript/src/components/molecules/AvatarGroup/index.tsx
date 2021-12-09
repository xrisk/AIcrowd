import React from 'react';
import cx from 'classnames';

import AvatarWithTier from 'src/components/atoms/AvatarWithTier';
import styles from './avatarGroup.module.scss';
const { groupItemOnCard } = styles;

import { Users } from 'src/types';

export type AvatarGroupProps = {
  users: [Users];
  loading: boolean;
  size?: 'sm' | 'lg' | 'md' | 'ml';
  onCard?: boolean;
  borderColor?: string;
  priority?: boolean;
};

const AvatarGroup = ({ users, loading, size, onCard, borderColor, priority }: AvatarGroupProps) => (
  <>
    <div className={cx(styles['avatar-group'])}>
      {users.map((user, index) => {
        const { tier, image } = user;
        return (
          <div className={cx(styles['avatar-group-item'], { [groupItemOnCard]: onCard })} key={index}>
            <AvatarWithTier
              tier={tier}
              image={image}
              loading={loading}
              size={size}
              onCard={onCard}
              borderColor={borderColor}
              priority={priority}
            />
          </div>
        );
      })}
    </div>
  </>
);

export default AvatarGroup;
