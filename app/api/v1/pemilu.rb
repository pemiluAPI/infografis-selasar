module Pemilu
  class APIv1 < Grape::API
    version 'v1', using: :accept_version_header
    prefix 'api'
    format :json

    resource :infografis do
      desc "Return all Infografis Selasar"
      get do
        grafis = Array.new

        InfografisSelasar.includes(:type)
          .each do |info|
            grafis << {
              id: info.id,
              judul: info.judul,
              type: {
                id: info.type.id,
                nama: info.type.nama
              },
              url_infografis: info.url_infografis
            }
          end

        {
          results: {
            count: grafis.count,
            infografis: grafis
          }
        }
      end

      desc "Return a Infografis Selasar"
      params do
        requires :id, type: Integer, desc: "Infografis Selasar ID."
      end
      route_param :id do
        get do
          grafis = InfografisSelasar.includes(:type).where(id: params[:id]).first
          {
            results: {
              count: 1,
              partai: [{
                  id: grafis.id,
                  judul: grafis.judul,
                  type: {
                    id: grafis.type.id,
                    nama: grafis.type.nama
                  },
                  url_infografis: grafis.url_infografis
              }]
            }
          }
        end
      end
    end
  end
end