import React from 'react';

import AvatarWithTier from './index';

const customAvatar1 = `/assets/images/custom-avatar-1.png`;
const customAvatar2 = `/assets/images/custom-avatar-2.png`;
const customAvatar3 = `/assets/images/custom-avatar-3.png`;
const customAvatar4 = `/assets/images/custom-avatar-4.png`;
const customAvatar5 = `/assets/images/custom-avatar-5.png`;
const customAvatar6 = `/assets/images/custom-avatar-6.png`;
const customAvatar7 = `/assets/images/custom-avatar-7.png`;
const customAvatar8 = `/assets/images/custom-avatar-8.png`;

// This default export determines where your story goes in the story list
export default {
  title: 'Atoms/Avatar with tier',
  component: AvatarWithTier,
  args: {
    tier: 1,
    image: customAvatar3,
    name: 'John Doe',
    organization: 'ABC Pvt Ltd.',
    city: 'Delhi',
    country: 'India',
    loading: false,
    size: 'default',
    onCard: false,
  },
  argTypes: {
    tier: {
      control: {
        type: 'select',
        options: ['0', '1', '2', '3', '4', '5'],
      },
    },
    size: {
      control: {
        type: 'radio',
        options: ['sm', 'md', 'ml', 'lg', 'default'],
      },
    },
    image: {
      control: {
        type: 'select',
        options: [
          customAvatar1,
          customAvatar2,
          customAvatar3,
          customAvatar4,
          customAvatar5,
          customAvatar6,
          customAvatar7,
          customAvatar8,
        ],
      },
    },
  },
};

const Template = args => <AvatarWithTier {...args} />;

export const avatarWithTier = Template.bind({});

avatarWithTier.parameters = {
  design: {
    type: 'figma',
    url: 'https://www.figma.com/file/Tb2YrjQAB4zsiQBS1YVWTy/New-website?node-id=2787%3A4997',
  },
};
