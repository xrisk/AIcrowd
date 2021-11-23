import { fetchDataFile } from 'src/api';

import { useQuery } from 'react-query';

export function useDataFile(params, config) {
  return useQuery(['data', params], () => fetchDataFile(params), {
    retry: false,
    refetchOnWindowFocus: false,
    ...config,
  });
}
