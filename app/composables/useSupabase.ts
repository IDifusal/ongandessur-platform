export function useSupabase() {
  const client = useSupabaseClient()

  function from(table: string) {
    return client.from(table)
  }

  function storage() {
    return client.storage.from('images')
  }

  function uploadImage(file: File, path: string) {
    return storage().upload(path, file)
  }

  function getImageUrl(path: string) {
    const { data } = storage().getPublicUrl(path)
    return data.publicUrl
  }

  return { client, from, storage, uploadImage, getImageUrl }
}
