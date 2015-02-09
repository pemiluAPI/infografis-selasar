module InfografisHelpers
  def build_type(infografis)
      infografis.type.nil? ? {} : {
        id: infografis.type.id,
        nama: infografis.type.nama
    }
  end
end

module Pemilu
  class APIv1 < Grape::API
    version 'v1', using: :accept_version_header
    prefix 'api'
    format :json

    resource :infografis do
      helpers InfografisHelpers

      desc "Return all Infografis Selasar"
      get do
        grafis = Array.new

        limit = (params[:limit].to_i == 0 || params[:limit].empty?) ? 10 : params[:limit]

        InfografisSelasar.includes(:type)
          .limit(limit)
          .offset(params[:offset])
          .each do |info|
            grafis << {
              id: info.id,
              judul: info.judul,
              type: build_type(info),
              url_infografis: info.url_infografis
            }
          end

        {
          results: {
            count: grafis.count,
            total: InfografisSelasar.count,
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
                  type: build_type(info),
                  url_infografis: grafis.url_infografis
              }]
            }
          }
        end
      end
    end
  end
end