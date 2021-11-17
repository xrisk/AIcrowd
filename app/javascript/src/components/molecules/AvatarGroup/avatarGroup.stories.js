import React from 'react';

import AvatarGroup from './index';

const customAvatar1 = `/assets/images/custom-avatar-1.png`;
const customAvatar2 = `/assets/images/custom-avatar-2.png`;
const customAvatar3 = `/assets/images/custom-avatar-3.png`;
const customAvatar4 = `/assets/images/custom-avatar-4.png`;
const customAvatar5 = `/assets/images/custom-avatar-5.png`;

// This default export determines where your story goes in the story list
export default {
  title: 'Molecules/AvatarGroup',
  component: AvatarGroup,
  args: {
    users: [
      { id: 1, image: customAvatar1, tier: 4 },
      { id: 2, image: customAvatar2, tier: 2 },
      { id: 3, image: customAvatar3, tier: 5 },
      { id: 4, image: customAvatar4, tier: 0 },
      { id: 5, image: customAvatar5, tier: 1 },
    ],
    loading: false,
    onCard: false,
    size: 'default',
  },
};

const Template = args => <AvatarGroup {...args} />;

export const avatarGroup = Template.bind({});
avatarGroup.args = {};
