import React from 'react';

import HorizontalScroll from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Utility/HorizontalScroll',
  args: {
    paddingLeft: '20px',
  },
  component: HorizontalScroll,
};

const styles = {
  imageStyle: {
    padding: '10px',
    minWidth: '200px',
  },
};

const list = [
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
  {
    link: 'https://i.ibb.co/WfMhk7c/Image-1.jpg',
  },
];

const Template = args => (
  <HorizontalScroll {...args}>
    {list.map((item, i) => {
      const { link } = item;
      return (
        <div className="card-image" key={i}>
          <img src={link} loading="lazy" style={styles.imageStyle} alt="Images"></img>
        </div>
      );
    })}
  </HorizontalScroll>
);

export const horizontalScroll = Template.bind({});
horizontalScroll.args = {};
