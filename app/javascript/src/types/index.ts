// import { PropTypes } from 'prop-types';

// export const buttonDefaultType = PropTypes.shape({
//   type: PropTypes.string,
//   text: PropTypes.string.isRequired,
//   disabled: PropTypes.bool,
//   hidden: PropTypes.bool,
//   iconClass: PropTypes.string,
//   to: PropTypes.string,
//   handleClick: PropTypes.func,
//   size: PropTypes.string,
//   iconColor: PropTypes.string,
//   fontWeight: PropTypes.string,
//   paddingRight: PropTypes.string,
//   paddingTop: PropTypes.string,
//   paddingBottom: PropTypes.string,
//   paddingLeft: PropTypes.string,
//   hoverBorder: PropTypes.string,
//   iconLeft: PropTypes.bool,
//   iconSize: PropTypes.string,
//   transparent: PropTypes.bool,
// });

export type AvatarSizeProps = 'sm' | 'lg' | 'md';

// Participants
export type Users = {
  id: number;
  tier: number;
  image: string;
};

export type ChallengeCardProps = {
  image: string;
  name: string;
  description: string;
  submissionCount: string;
  organizerImage: string;
  prizes: Array<string>;
  hashtags: Array<string>;
  /** Participants on challenge card */
  users: [Users];
  color: string;
  badgeColor: string;
  challengeEndDate: string;
  cardBadge: boolean;
  loading: boolean;
};

export type WinningChallengeCardProps = {
  name: string;
  prize: string;
  users: [Users];
  color: string;
  link: string;
  borderColor: string;
  type: string;
  text: string;
  hidden: boolean;
  disabled: boolean;
  loading: boolean;
  iconClass?: string;
  iconLeft?: boolean;
};

export type WinningTeamCardProps = {
  name: string;
  description: string;
  color: string;
  link: string;
  borderColor: string;
  type: string;
  text: string;
  hidden: boolean;
  disabled: boolean;
  loading: boolean;
  tier: number;
  image: string;
  onCard: boolean;
  size?: 'sm' | 'lg' | 'md' | 'ml';
  hideActionItem: boolean;
};

declare module 'react' {
  interface HTMLAttributes<T> extends AriaAttributes, DOMAttributes<T> {
    // extends React's HTMLAttributes
    objectFit?: any;
    priority?: any;
    blurDataURL?: string;
    layout?: string;
  }
}
