import { PropTypes } from 'prop-types';

export const organisersType = PropTypes.shape({
  image: PropTypes.string,
  name: PropTypes.string,
});

export const roundsType = PropTypes.shape({
  end_time: PropTypes.string,
  name: PropTypes.string,
  start_time: PropTypes.string,
});

export const statsType = PropTypes.shape({
  participants: PropTypes.number,
  submissions: PropTypes.number,
  teams: PropTypes.number,
});

export const challengeHeadType = PropTypes.shape({
  can_create_team: PropTypes.bool,
  can_participate: PropTypes.bool,
  categories: PropTypes.arrayOf(PropTypes.string),
  description: PropTypes.string,
  image: PropTypes.string,
  likes: PropTypes.number,
  name: PropTypes.string,
  organisers: PropTypes.arrayOf(organisersType),
  rounds: PropTypes.arrayOf(roundsType),
  stats: statsType,
});
